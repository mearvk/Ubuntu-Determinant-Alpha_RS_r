require 'dhelp'

path = ARGV.shift || Dhelp::DOC_DIR_DATABASE
puts "Opening #{path}"
ddd = Dhelp::DocDirDatabase.open(DBM::READER, path)
ddd.each do |dir, doc_id, title|
  puts "#{dir} -> #{doc_id} (#{title})"
end
