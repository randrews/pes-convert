require 'fileutils'

def rename_caps files
  files.each do |file|
    if file =~ /(.*)\.PES/
      FileUtils.mv file, "#{$1}.pes"
    end
  end
end

# files is a list of paths relative to the .
# dest is a path to a dir
def convert files, dest
  File.open("errors.log", "a") do |log|
    files.each_with_index do |file, index|
      FileUtils.mkdir_p File.join(dest,File.dirname(file))
      basename = File.join(dest, File.dirname(file), File.basename(file,".pes"))

      if File.exists?(basename+".png")
        puts "skipping #{index} - file exists: #{file}"
        next
      end

      puts "creating #{index} of #{files.size} - #{file}"

      begin
        `php /home/randrews/Desktop/pes2png/pes_svg.php "#{file}" > "#{basename}.svg"`
        `inkscape -f "#{basename}.svg" -e "#{basename}.png"`
        FileUtils.rm(basename+".svg")
      rescue
        log.puts $!.backtrace
      end
    end
  end
end
