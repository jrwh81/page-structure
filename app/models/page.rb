class Page < ApplicationRecord
	mount_uploader :csv, CsvUploader
	has_ancestry
end
