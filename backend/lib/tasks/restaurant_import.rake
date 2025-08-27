namespace :restaurant do
  desc "Import restaurants from JSON file"
  task :import, [ :file_path ] => :environment do |task, args|
    file_path = args[:file_path]

    unless file_path
      puts "Usage: rails restaurant:import[path/to/file.json]"
      exit 1
    end

    puts "Starting restaurant import from: #{file_path}"
    puts "=" * 50

    service = RestaurantImportService.new
    result = service.import_from_file(file_path)

    if result[:success]
      puts "Import completed successfully"
      puts
      puts "Summary:"
      result[:summary].each do |key, value|
        puts "  #{key.to_s.humanize}: #{value}"
      end

      puts
      puts "Import Logs:"
      result[:logs].each do |log|
        puts "#{log[:message]}"
      end
    else
      puts "Import failed"
      puts
      puts "Errors:"
      result[:errors].each do |error|
        puts "  • #{error}"
      end

      puts
      puts "Logs:"
      result[:logs].each do |log|
        puts "  #{log[:type].upcase}: #{log[:message]}"
      end
      exit 1
    end
  end
end
