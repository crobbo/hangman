class SaveLoad
  
  def save_game
    File.open("save.yml", "w") { |f| f.write YAML::dump(self)}
    @save_game = true
  end

  def load_game
    file_to_load = Dir.chdir("save_files") { Dir.glob("*.yaml").sort[choice] }
    loaded_game = YAML.safe_load(File.read("save_files/#{file_to_load}"), [Symbol])
  end

end
