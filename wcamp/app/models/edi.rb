class Edi

	def initialize
		@host = "http://www.miyabiit.com"
		@user = "baker"
		@pass = "street221b"
		@get_dir = "/var/www/html/wbirdfirm/tmp/"
		@put_dir = "/var/www/html/wbirdfirm/tmp/"
	end
	
	def self.get_bf_files
		Net::SSH.start(@host, @user, :password => @pass) do |ssh|
			scp.download!	
	end

	def put_bf_file file
		return false unless File.exist?(file)
		remote_file = @put_dir  + '/' + DateTime.now.strftime('%Y%m%d%H%M') + '-' + File.basename(file)
		Net::SSH.start(@host, @user, :password => @pass) do |ssh|
			if ssh.upload!(file, remote_file)			
				# ssh.exec!("touch test.txt")
			end
		end
	end
end
