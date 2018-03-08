module Hyrax
  # Returns Works that the current user has permission to use.
  class WorksCountService < CountService
    def initialize(context, search_builder, model, params)
      super(context, search_builder, model)

      @params = params
      @draw = 0
    end

    # Returns list of works
    # @param [Symbol] access :read or :edit
    # @return [Array<Hyrax::WorksCountService::SearchResultForWorkCount>] a list with documents
    def search_results_with_work_count(access)
      works = search_results(access)
      results = []

      works.each do |work|
        created_date = DateTime.parse(work['system_create_dtsi']).in_time_zone.strftime("%Y-%m-%d")
        results << [work.title, created_date, 0, work['human_readable_type_tesim'][0], work['visibility_ssi']]
      end

      { draw: @draw += 1,
        recordsTotal: works.length,
        recordsFiltered: 2,
        data: results }
    end

    private

      def builder(_)
        sort_ordering = if @draw.zero?
                          'desc'
                        else
                          @params[:order][0]['dir']
                        end

        search_builder.new(context)
                      .start(@params[:start])
                      .rows(@params[:length])
      end
  end
end
