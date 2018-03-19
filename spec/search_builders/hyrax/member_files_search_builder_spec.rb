RSpec.describe Hyrax::MemberFilesSearchBuilder do
  let(:processor_chain) { [:filter_models] }
  let(:solr_params) { { fq: [] } }
  let(:item) { double(id: '12345') }
  let(:builder) { described_class.new(solr_params, context) }
  let(:context) { double("context", blacklight_config: CatalogController.blacklight_config, item: item) }

  subject { described_class.new(context) }

  describe '#filter_models' do
    before { subject.filter_models(solr_params) }

    it 'adds FileSet to query' do
      expect(solr_params[:fq].first).to include('{!terms f=has_model_ssim}FileSet')
    end
  end

  describe '#include_item_ids' do
    let(:subject) { builder.member_files(solr_params) }

    it 'updates solr_parameters[:fq]' do
      subject
      expect(solr_params[:fq]).to include("{!join from=file_set_ids_ssim to=id}id:12345")
    end
  end
end
