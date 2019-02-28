# Savvy

**Elixir SDK for Savvy https://www.savvy.io**

You need to export the following environment variables with you own values before the
Installation step:

```
  export SAVVY_URL="https://api.test.savvy.io"
  
  export SAVVY_SECRET="YOUSAVVYSECRECT"
  
  export SAVVY_CALLBACK="http://localhost"
```

 after that, you need to put the following configuration in you config files:
 
 ```
 config :savvy,
    url: System.get_env("SAVVY_URL"),
    secret: System.get_env("SAVVY_SECRET"),
    callback: System.get_env("SAVVY_CALLBACK")
```

## Installation

The package is [available in Hex](https://hex.pm/packages/savvy), and can be installed
by adding `savvy` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:savvy, "~> 0.1.0"}
  ]
end
```

The documentation can be found at [https://hexdocs.pm/savvy](https://hexdocs.pm/savvy).

