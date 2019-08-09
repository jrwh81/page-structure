require 'rails_helper'

RSpec.describe PagesController, :type => :controller do
	context "GET new" do
		it "assigns a blank page to the view" do
			get :new
			expect(assigns(:page)).to be_a_new(Page)
		end
	end

	context "POST create" do
		it "shows a master page and tree structure" do
			csv_file = fixture_file_upload("/files/eq_page_outline_v2point1.csv", 'csv')
			post :create, params: { page: { csv: csv_file }  }
			expect(response).to have_http_status(:redirect)
			expect(assigns(:page).csv.filename).to eq("eq_page_outline_v2point1.csv")
			expect(assigns(:master_page).name).to eq("Home")
		end

		it "validates the csv and catches malformities" do
			csv_file = fixture_file_upload("/files/malformed-csv.csv", 'csv')
			post :create, params: { page: { csv: csv_file }  }
			expect(assigns(:page).errors.messages[:base]).to eq(["#<CSV::MalformedCSVError: Unclosed quoted field on line 1.>"])
		end

		it "only allows csvs to be uploaded" do
			file = fixture_file_upload("/files/sample.txt", 'txt')
			post :create, params: { page: { csv: file }  }
			expect(assigns(:page).errors.messages[:csv]).to eq(["You are not allowed to upload \"txt\" files, allowed types: csv"])
		end	
	end

	context "GET show" do
		it "retrieves and displays all Pages" do
			page = Page.create
			get :index
			expect(assigns(:pages)).to eq([page])
		end

		it "renders the index template" do
			get :index
			expect(response).to render_template("index")
		end
	end
end