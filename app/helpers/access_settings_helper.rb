module AccessSettingsHelper
  def check_audit_changes(audit_changes)
    value_exist = false
    audit_changes.keys.each do |key|
      if audit_changes[key].eql? [nil, ""]
        audit_changes = audit_changes.except!(key)
      elsif key.downcase.eql? "phone_number" and audit_changes[key].first.gsub(/\D/, "").eql?(audit_changes[key].second.gsub(/\D/, ""))
        audit_changes = audit_changes.except!(key)
      else
        value_exist = true
      end
    end
    return audit_changes, value_exist
  end
end
