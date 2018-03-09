module Hyrax
  # Returns Works that the current user has permission to use.
  class WorksCountService < CountService
    def initialize(context, params)
      super(context)

      @params = params
    end

    # Returns list of works
    # @param [Symbol] access :read or :edit
    # @return [Array<Hyrax::WorksCountService::SearchResultForWorkCount>] a list with documents
    def search_results_with_work_count(access)
      works = search_results(access)
      results = []

      works.documents.each do |work|
        created_date = DateTime.parse(work['system_create_dtsi']).in_time_zone.strftime("%Y-%m-%d")
        results << [work.title, created_date, 0, work['human_readable_type_tesim'][0], work['visibility_ssi']]
      end

      { draw: @params[:draw],
        recordsTotal: works['response']['numFound'],
        recordsFiltered: works.documents.length,
        data: results }
    end

    def search_results(access)
      context.repository.search(builder(access))
    end

    private

      def builder(_)
        search_builder.new(context, @params)
                      .start(@params[:start])
                      .rows(@params[:length])
      end
  end
end
