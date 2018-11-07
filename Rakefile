require 'ant'

PROJECT_NAME = 'hello'
MAIN_SRC_DIR = 'lib'
JARS_DIR = 'jars'
BUILD_DIR = 'build'
DIST_DIR = "#{BUILD_DIR}/dist"
COMPILE_DIR = "#{BUILD_DIR}/compile"
CLASSES_DIR = "#{COMPILE_DIR}/classes"

task default: [:clean, :package]

task :clean do
  ant.delete dir: BUILD_DIR
  puts
end

task :setup do
  ant.path id: 'classpath' do
    fileset dir: COMPILE_DIR
    fileset dir: JARS_DIR
  end
end

task package: [:setup, :download_jruby_complete, :package_gems_into_jar] do
  make_jar MAIN_SRC_DIR, "#{PROJECT_NAME}.jar"
  puts "Done"
end

def make_jar(source_folder, jar_file_name)
  ant.mkdir dir: CLASSES_DIR
  `jrubyc ./lib/hello.rb -t #{CLASSES_DIR} --javac`
  ant.javac srcdir: source_folder,
            destdir: CLASSES_DIR,
            classpathref: 'classpath',
            source: "0.1",
            debug: "yes",
            includeantruntime: "no"
  ant.jar jarfile: "#{COMPILE_DIR}/#{jar_file_name}", basedir: CLASSES_DIR do
    zipgroupfileset dir: JARS_DIR, includes: "jruby-complete-#{jruby_version}.jar"
    zipgroupfileset dir: JARS_DIR, includes: "gems.jar"
  end
  puts
end

def jruby_version
  @jruby_version ||= File.open('.ruby-version').read.strip.gsub('jruby-', '')
end

task :download_jruby_complete do
  path = "https://repo1.maven.org/maven2/org/jruby/jruby-complete/#{jruby_version}/jruby-complete-#{jruby_version}.jar"
  output_file = "jars/jruby-complete-#{jruby_version}.jar"
  unless File.exist?(output_file)
    puts "Downloading jruby-complete from:\n#{path}\nto: #{output_file}"
    require 'open-uri'
    open(output_file, 'wb') do |file|
      file << open(path).read
    end
    puts "Done"
  end
end

task :package_gems_into_jar do
  specs = Bundler.load.specs
  gems = specs.collect { |spec| spec.name + ':' + spec.version.to_s }.join(' ')
  FileUtils.rm_rf("tmp")
  puts "installing #{gems} gems in a jar"
  cmd = "java -jar jars/jruby-complete-#{jruby_version}.jar -S gem install -i tmp --no-ri --no-rdoc #{gems}"
  system(cmd)
  puts "Creating jars/gems.jar file"
  FileUtils.rm_f("jars/gems.jar")
  cmd = "jar cf jars/gems.jar -C tmp ."
  system(cmd)
  FileUtils.rm_rf("tmp")
  puts "Done"
end
