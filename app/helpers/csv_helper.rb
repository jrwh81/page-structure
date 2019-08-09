require 'csv'

module CsvHelper
	def validate_csv(page)
		return page if !page.valid?
		csv_content = page.csv.read
		begin
			CSV.parse(csv_content, headers: true)
		rescue CSV::MalformedCSVError => exception
			page.errors.add(:base, exception.inspect)
		end
	end

	def process_csv(csv)
		csv_content = csv.read
		pages = CSV.parse(csv_content, headers: true)
		master_page = ''
		pages.each do |page|
			if page["parent_path"].nil?
				page["parent_path"] = ''
				master_page = page			
			end
			relative_path = page["parent_path"] + page["slug"]
			new_page = Page.create(name: page["name"], 
														 parent_path: page["parent_path"], 
														 slug: page["slug"],
														 csv_id: csv.url,
														 relative_path: relative_path)
			new_page.save!
			assign_parent(new_page) unless new_page.parent_path.blank?
			master_page = new_page.root
		end

		master_page
	end

	def assign_parent(page)
		if page.parent_path != '/'
			parent_page_slug = page.parent_path.gsub('/', '')
		else
			parent_page_slug = page.parent_path
		end
		parent_page = Page.find_by(slug: parent_page_slug, csv_id: page.csv_id)
		page.parent = parent_page
		page.save!
	end
end  