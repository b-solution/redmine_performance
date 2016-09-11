require_dependency 'custom_field'

module  RedminePerf
  module  Patches
    module CustomFieldPatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do

          scope :visible, lambda {|*args|
            user = args.shift || User.current
            if user.admin?
              # nop
            elsif user.memberships.count > 0
              where("#{table_name}.visible = ? OR #{table_name}.id IN (SELECT DISTINCT cfr.custom_field_id FROM #{Member.table_name} m" +
                        " INNER JOIN #{MemberRole.table_name} mr ON mr.member_id = m.id" +
                        " INNER JOIN #{table_name_prefix}custom_fields_roles#{table_name_suffix} cfr ON cfr.role_id = mr.role_id" +
                        " WHERE m.user_id = ?)",
                    true, user.id)
            else
              where(:visible => true)
            end
          }
        end
      end
    end
    module InstanceMethods
    end

    module ClassMethods

    end

  end
end
