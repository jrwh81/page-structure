require "rails_helper"

RSpec.describe CsvHelper, :type => :helper do
  describe "#validate_csv" do
     it "passes clean csv" do
      csv_file = fixture_file_upload("/files/eq_page_outline_v2point1.csv", 'csv')
      page = Page.new(csv: csv_file)
      helper.validate_csv(page)
      expect(page.errors.blank?).to eq(true)
    end
     	
    it "catches malformities" do
      csv_file = fixture_file_upload("/files/malformed-csv.csv", 'csv')
      page = Page.new(csv: csv_file)
      helper.validate_csv(page)
      expect(page.errors.present?).to eq(true)
    end
  end

  describe "#process_csv" do
  	it "returns master page from csv contents" do
      csv_file = fixture_file_upload("/files/eq_page_outline_v2point1.csv", 'csv')
      page = Page.new(csv: csv_file)
      master_page = helper.process_csv(page.csv)
      expect(master_page.name).to eq("Home")
      expect(master_page.parent).to eq(nil)
  	end
  end

  describe "#assign_parent" do
  	it "assigns the parent page to the page" do
  		parent_page = Page.new(name: "Home", slug: "/", csv_id: "test_csv")
  		parent_page.save
  		child_page = Page.new(name: "About", slug: "about", parent_path: "/", csv_id: "test_csv")
  		child_page.save
  		helper.assign_parent(child_page)
  		expect(child_page.parent).to eq(parent_page)
  	end
  end
end