def symbolize(str)
  str.to_s.downcase.gsub(' ', '_').to_sym
end

def stringify(sym)
  sym.to_s.gsub('_', ' ').split(' ').map(&:capitalize).join(' ')
end
