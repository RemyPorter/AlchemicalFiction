defmodule GameMacros do
    use Story

    scene ASimpleScene, "There's nothing here" do
        feature :door, :simple, "A simple exit" do
            action :examine do
                {var!(feature_state), {:see, "This simple exit is unmarked."}}
            end
            action :use do
                #get actor, feature state, actor state
            end
        end
        feature :item, :wrench, "A wrench" do
            action :take do
                
            end
        end
    end

    spawn_point(ASimpleScene)
end