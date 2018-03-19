# returns a list of solr documents for the authorized file sets the item has
module Hyrax
  class MemberFilesService
    include Blacklight::Configurable
    include Blacklight::SearchHelper

    attr_reader :item, :current_ability

    copy_blacklight_config_from(CatalogController)

    # @param [SolrDocument] item represents a work
    def self.run(item, ability)
      new(item, ability).list_member_files
    end

    def initialize(item, ability)
      @item = item
      @current_ability = ability
    end

    def list_member_files
      query = member_files_search_builder.rows(1000)
      resp = repository.search(query)
      resp.documents
    end

    def member_files_search_builder
      @member_files_search_builder ||= MemberFilesSearchBuilder.new(self)
    end
  end
end
