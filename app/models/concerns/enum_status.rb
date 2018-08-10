# frozen_string_literal: true

module EnumStatus
  def enum_status(*statuses)
    statuses.flatten.each do |name|
      n = name.demodulize
      const_set("#{n}_NAMES", HashWithIndifferentAccess[*const_get(name).map { |e| [e[0], e[2]] }.flatten].freeze)

      send(:enum, n.downcase => Hash[*const_get(name).map { |e| [e[0], e[1]] }.flatten].freeze)
      define_method(n.downcase + '_name') do
        self.class.const_get("#{n}_NAMES")[send(n.downcase)]
      end
    end
  end
end
