desc "import ship orders"
task :import_ship_order_file => :environment do
	EdiFile.edi_shipping
end

desc "import receive file"
task :import_receive_file => :environment do
	EdiFile.edi_receiving
end
