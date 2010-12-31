require "net/ssh"
require "net/sftp"
require "fileutils"
class Edi

	def initialize
		@config = YAML.load_file(RAILS_ROOT + "/config/edi/edi.yml")
	end
	
	def self.before_upload tag
	end

	def self.after_upload tag
	end

	def self.before_download tag
	end

	def self.after_download tag
	end
	
	def upload_file tag = ""
		RAILS_DEFAULT_LOGGER.debug @config
		host = @config[:birdfarm][:host]
		user = @config[:birdfarm][:user]
		pass = @config[:birdfarm][:pass]
		#
		Edi.before_upload tag
		local_file = $UPLOAD_DIR + '/' + $WareHouseCode + "-" + tag + ".csv"
		remote_file = @config[:birdfarm][:receive_dir] + "/" + $WareHouseCode + "-" + tag + ".csv"
		unless File.exist?(local_file)
			RAILS_DEFAULT_LOGGER.error "no file for upload"
			return false 
		end
		Net::SFTP.start(host, user, :password => pass) do |sftp|
			if sftp.upload!(local_file, remote_file)			
				backup_file = $BACKUP_DIR + "/" + File.basename(local_file,".csv") + "-" + DateTime.now.strftime("%Y%m%d%H%M%S") + ".csv.bak"
				FileUtils.mv local_file , backup_file
			end
		end
		Edi.after_upload tag
	end
	
	def download_file tag = ""
		host = @config[:birdfarm][:host]
		user = @config[:birdfarm][:user]
		pass = @config[:birdfarm][:pass]
		#
		Edi.before_download tag
		remote_dir = @config[:birdfarm][:send_dir] 
		remote_file = $WareHouseCode + "-" + tag + '*'
		local_dir = $DOWNLOAD_DIR 
		
		Net::SFTP.start(host, user, :password => pass) do |sftp|
			begin
				sftp.dir.glob(remote_dir,remote_file) do |e| 
					#unless sftp.stat(e).directory?
						remote_file = remote_dir + '/' + e.name
						local_file = local_dir + '/' + $WareHouseCode + "-" + tag + "-" + Date.now.strftime("%Y%m%d%H%M%S") + File.extname(e.name)
						if sftp.download!(remote_file, local_file)
							sftp.remove!(remote_file)
						end
					#end
				end
			rescue 
				RAILS_DEFAULT_LOGGER.error $!
			end
		end
		Edi.after_upload tag
	end
end
