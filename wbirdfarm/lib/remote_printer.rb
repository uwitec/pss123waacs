module RemotePrinter
	require "rubygems"
	#require "net/ssh"
	#require "net/sftp"
	require "csv"
	require "fileutils"
		
=begin
	def remote_print file
		# this method needs "print.rb" on remote_side.
		# initialize
		host = "192.168.4.9"
		user = "baker"
		passwd = "street221b"
		remote_dir = "/home/baker"
		#
		return false unless File.exist?(file)
		remote_file = remote_dir + '/' + File.basename(file)
		Net::SSH.start(host, user, :password => passwd) do |ssh|
			if ssh.sftp.upload!(file, remote_file)
				ssh.exec!("ruby print.rb #{remote_file}")
			end
		end
	end
=end

	def remote_print file
		system("ruby lib/print.rb #{file}") 
	end
end
