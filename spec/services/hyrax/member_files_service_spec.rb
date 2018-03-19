RSpec.describe Hyrax::MemberFilesService, :clean_repo do
  let(:user) { create(:user) }
  let!(:ability) { ::Ability.new(user) }
  let!(:file_set1) { build(:file_set, id: 'file_set1', user: user) }
  let!(:file_set2) { build(:file_set, id: 'file_set2') }
  let(:work) { create(:public_work, ordered_members: [file_set1, file_set2]) }

  describe "#run" do
    subject { described_class.run(work, ability) }

    it "returns only authorized files" do
      expect(subject.count).to eq(1)
      ids = subject.map { |file| file[:id] }
      expect(ids).to contain_exactly(file_set1.id)
    end
  end
end
