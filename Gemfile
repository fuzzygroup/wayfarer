gemfile = if RUBY_PLATFORM == "java"
            File.expand_path("../gemfiles/Gemfile-jruby", __FILE__)
          else
            File.expand_path("../gemfiles/Gemfile-mri", __FILE__)
          end

eval(File.read(gemfile))
