# Mud

This is incredibly incomplete and can't be run as an application, *yet*. I'm getting there.

Mud is a flexible interactive fiction engine, designed to be easily extensible, based around a DSL. Eventually, users will be able to design games with a very simple and focused domain-specific-language that retains a great deal of flexibliity (and can be easily extended). Think Twine, but more powerful.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `mud` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:mud, "~> 0.1.0"}]
    end
    ```

  2. Ensure `mud` is started before your application:

    ```elixir
    def application do
      [applications: [:mud]]
    end
    ```

