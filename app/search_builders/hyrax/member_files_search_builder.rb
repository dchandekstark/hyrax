module Hyrax
  # Finds the child objects contained within a collection
  class MemberFilesSearchBuilder < ::SearchBuilder
    include FilterByType

    self.default_processor_chain += [:member_files]

    def member_files(solr_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << "{!join from=file_set_ids_ssim to=id}id:#{scope.item.id}"
    end

    # This overrides the models in FilterByType
    def models
      [::FileSet]
    end
  end
end
