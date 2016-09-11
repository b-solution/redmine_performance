require_dependency 'user'

module  RedminePerf
  module  Patches
    module MyHelperPatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :news_items, :perf
          alias_method_chain :calendar_items, :perf

        end
      end
    end
    module ClassMethods
    end

    module InstanceMethods
      def news_items_with_perf
        News.visible.
            where(:project_id => User.current.projects.pluck(:id)).
            limit(10).
            includes(:project, :author).
            references(:project, :author).
            order("#{News.table_name}.created_on DESC").
            to_a
      end

      def calendar_items_with_perf(startdt, enddt)
        Issue.visible.
            where(:project_id => User.current.projects.pluck(:id)).
            where("(start_date>=? and start_date<=?) or (due_date>=? and due_date<=?)", startdt, enddt, startdt, enddt).
            includes(:project, :tracker, :priority, :assigned_to).
            references(:project, :tracker, :priority, :assigned_to).
            to_a
      end
    end

  end
end
