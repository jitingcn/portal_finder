class PortalSetImageHashJob < ApplicationJob
  queue_as :portal_job


  def perform(arg)
    return if (arg.nil? || arg[:id].nil?)
    Tempfile.open("portal-", Rails.root.join("tmp")) do |f|
      IO.copy_stream(URI.open(arg[:image_url]), f.path)
      f.close
      image = Phashion::Image.new(f.path)
      Portal.find(arg[:id]).update(image_hash: image.fingerprint)
      f.unlink
    rescue Exception => e
      puts e.message
      f.close!
    end
  end
end
