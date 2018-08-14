module ApiHelperBase
  extend ActiveSupport::Concern
  extend Grape::API::Helpers

  def session
    env['rack.session']
  end

  def current_user
    return @user if @user
    if headers["Token"].present?
      @user ||= User.where(token: headers["Token"]).first
      if @user.present? && (@user.last_sign_in_at + 7.days) < Time.now
        @user = nil
      end
    end
    if (Rails.env.staging? || Rails.env.testing? || Rails.env.development? ) && params[:current_user_id].present?
      @user ||= User.new(id: params[:current_user_id])
    end
    @user
  end

  def logger
    API.logger
  end

  def permitted_params
    @permitted_params ||= ActionController::Parameters.new(declared(params, include_missing: false)).permit!
  end

  def remote_ip
    headers["X-Real-Ip"] || env['REMOTE_ADDR']
  end

  def set_attrs object, params
    params.each{|k,v|
      object.send("#{k}=",v)
    }
    object
  end

  def format_error object
    object.errors.messages.map{|k,v| "#{k} -> #{v.join(', ')}"}.join(', ')
  end

  def format_vali_error_msg obj
    return obj.errors.messages.map{|k,v| v}.join(', ')
  end

  def format_vali_error_data obj
    return {error_data: obj.errors.messages, error_type: 'validation_error'}
  end

  def paginate res, page=nil, per_page=nil
    page ||= params[:page]
    per_page ||= params[:per_page]
    res = res.paginate page: page, per_page: per_page > 50 ? 50 : per_page
    return res
  end

  def return_success result = {}, opt={}
    header 'X-Robots-Tag', 'noindex, nofollow'
    header 'Ts', Time.now.to_i
    status(200)

    res = {status: true, data: result}

    if res[:data].respond_to?(:total_pages) && res[:data].total_pages.present?
      res.merge!({
        per_page: res[:data].per_page,
        page: res[:data].current_page,
        total_pages: res[:data].total_pages,
        total_entries: res[:data].total_entries,
      })
    end
    present res
    present(:data, res[:data], opt) if opt.present?
  end

  def return_fail(error, params={})
    header 'X-Robots-Tag', 'noindex, nofollow'
    header 'Ts', Time.now.to_i
    status(200)

    ret = {status: false, error: error}
    ret[:error_type] = params[:error_type] if params[:error_type]
    ret[:error_data] = params[:error_data] if params[:error_data]
    ret[:data] =  params[:data] if  params[:data]
    present(ret)
  end

  def return_error!(result = {}, http_error_code)
    header 'X-Robots-Tag', 'noindex, nofollow'
    header 'Ts', Time.now.to_i

    error!(result, http_error_code, headers)
  end
end
