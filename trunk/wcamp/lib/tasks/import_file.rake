desc "import ship orders"
task :import_ship_order_file => :environment do
	import_file = $IMPORT_DIR + '/' + 'ship_orders.csv'
	if RAILS_ENV == 'development'
		FileUtils.cp RAILS_ROOT + '/test/fixtures/' + 'ship_orders.csv', import_file
	end
	ShipOrder.new.import_file(import_file)	
end

task :import_receive_file => :environment do
	import_file = $IMPORT_DIR + '/' + 'receives.csv'
	if RAILS_ENV == 'development'
		FileUtils.cp RAILS_ROOT + '/test/fixtures/' + 'receives.csv', import_file
	end
	Receive.new.import_file(import_file)
end
