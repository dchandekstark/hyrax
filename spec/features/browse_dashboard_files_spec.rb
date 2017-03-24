RSpec.describe "Browse Dashboard", type: :feature do
  let(:user) { create(:user) }
  let!(:dissertation) do
    create(:public_work, user: user, title: ["Fake PDF Title"], subject: %w(lorem ipsum dolor sit amet))
  end
  let!(:mp3_work) do
    create(:public_work, user: user, title: ["Test Document MP3"], subject: %w(consectetur adipisicing elit))
  end
  let!(:audio_work) do
    create(:public_work, user: user, title: ["Fake Wav Files"], subject: %w(sed do eiusmod tempor incididunt ut labore))
  end

  before do
    # Grant the user access to deposit into an admin set.
    create(:permission_template_access,
           :deposit,
           permission_template: create(:permission_template, with_admin_set: true),
           agent_type: 'user',
           agent_id: user.user_key)

    sign_in user
    user.trophies.create!(work_id: dissertation.id)
    visit "/dashboard"
  end

  it "lets the user search and display their files" do
    expect(page).to have_link "Create Collection"
    expect(page).to have_link "Create Work"

    # Search
    fill_in "q", with: "PDF"
    click_button "search-submit-header"
    expect(page).to have_content("Fake PDF Title")

    visit "/dashboard/works"
    fill_in "q", with: "PDF"
    click_button "search-submit-header"
    expect(page).to have_content("Fake PDF Title")
    within(".constraints-container") do
      expect(page).to have_content("You searched for:")
      expect(page).to have_css("span.glyphicon-remove")
      find(".dropdown-toggle").click
    end
    expect(page).to have_content("Fake Wav File")

    # Browse facets
    click_link "Subject"
    click_link "more Subjects"
    click_link "consectetur"

    within("#document_#{mp3_work.id}") do
      expect(page).to have_link("Display all details of Test Document MP3",
                                href: hyrax_generic_work_path(mp3_work, locale: 'en'))
    end
    click_link("Remove constraint Subject: consectetur")

    # Refresh the page
    click_button "Refresh"
    within("#document_#{dissertation.id}") do
      click_button("Select an action")
      expect(page).to have_content("Edit Work")
    end

    # View other tabs
    ["My Collections", "My Highlights", "Works Shared with Me"].each do |tab|
      within("#my_nav") do
        click_link(tab)
      end
      expect(page).to have_content(tab)
    end
  end

  it "allows me to delete works in upload_sets", js: true do
    visit "/dashboard/works"
    first('input#check_all').click
    expect do
      click_button('Delete Selected')
    end.to change { GenericWork.count }.by(-3)
  end
end
