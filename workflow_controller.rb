class WorkflowController < ApplicationController
	
	def start
		render :file => 'app/views/workflow/uploadfile.rhtml'
	end

	def uploadFile
		path = WorkflowDataFile.save(params[:upload])
		WorkflowDataFile.feed_generate(path, params[:jordan_template] == nil ? false : true)

		file_text = File.read('app/views/workflow/station.html')
		render :text => file_text
	end

	def view
		file_text = File.read('app/views/workflow/station.html')
		render :text => file_text
	end
end