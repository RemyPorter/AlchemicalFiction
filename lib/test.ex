defmodule GameMacros do
    use Story
    use BasicElements

    story_title "A really boring tale"
    
    scene ASimpleScene, "There's nothing here" do
        feature :door, :simple, "A simple exit" do
            action :examine do
                reply({:see, "This simple exit is unmarked."})
            end
            action :use do
                reply({:move, ASimpleScene})
            end
        end
        feature :item, :wrench, "A wrench" do
            action :take do
                
            end
        end
    end

    actor_spawn(ASimpleScene)
end