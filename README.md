# Betterdoc::Containerservice

This gem is designed to encapsulate all the common functionality needed within our cointainer services (e.g. authentication and special log handling).

It's **very** opinionated based on what our team needs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'betterdoc-containerservice', git: 'https://github.com/betterdoc-org/general-gem-betterdoc-containerservice'
```

You can also add the railtie manually into your Rails `config/application.rb` file but the logics should be applied automatically as well.

```ruby
require "betterdoc/containerservice/railtie"
```

## Configuration

### Required environment variables

The following environment variables must to be set in order for any container service depending on this gem to work correctly:

| Variable name | Description |
| ------------- | ----------- |
| `JWT_PUBLIC_KEY` | The RSA public key which is used to validate JSON Web Tokens sent to any controller. |
| `JWT_VALIDATION_ALGORITHM` | The algoritm to use when validating the JSON Web Token (should be `RS256` by default). |

### Optional environment variables

The following environment variables can be set to further customize the functionalities:

| Variable name | Description |
| ------------- | ----------- |
| `JWT_VALIDATION_ENABLED` | Can be set to `false` to disable the validation of incoming JSON Web Tokens. **Only use this setting in a local development environment**. |
| `CONTAINERSERVICE_FULL_HTML` | Can be set to `true` to add a default HTML header and footer, so that the HTML generated by the container service isn't just the plain snippet to be included in Stacker but can also be used in a standalone environment. **Should only be used in a local development environment**. |

## Functionalities

The following functionalities are automatically added to your Rails application:

### Logging

Use the [Logging](https://github.com/TwP/logging) framework (incl. its [Railtie](https://github.com/TwP/logging-rails)) and setzp our common log format.

### Controllers

#### Authentication

**All** controller are enhanced to require a valid JSON Web Token (JWT) on each invocation either as HTTP header `Authoriaztion` in the format `Authorization: Bearer 1234567890ABCEEF` or as HTTP parameter `_jwt` in the format `1234567890ABCDEF`.

#### Rendering shortcuts

The following code snippes demonstrate some shortcuts that can be used to render responses:

##### Errors

```ruby
def some_controller_method
  return render_containerservice_error(404, "Object not found") if object_not_found
  
  # ...
  
end
```

#### Templates

```ruby
def some_controller_method
  render_containerservice_template(:template_name)
end
```

Renders the template specified under `:template_name`.

Only if either the HTTP parameter `full_html` is set to `true` for the current request or an environment variable named `CONTAINERSERVICE_FULL_HTML` is set to `true` will the layout be applied to the template. 
Otherwise (the default case) only the plain template will be rendered and returned to the client.

### Helpers

#### URL and link generation

When the content of the container service is rendered inside a Stack (composed by Stacker) the following helper functionality is available to create a link to another Stack with the same Stacker instance.

Let's take an example:

A Stack is available at `http://example.com/stack/abc`. 
This stack aggregates the content from services `foo` and `bar`.
With the content of `foo` we want to link to another stack named `def`:

```html
<div>
  <a href="$ROOT_URL/def">Go to other stack</a>
</div>
```

To make sure the container service itself doesn't have to know about the actual location of Stacker (the `$ROOT_URL`) Stacker sends along a series of HTTP headers that tell the container service on which system it is running and which base URL to use.

So all that needs to be done wither within a template is to call the helper function `create_stacker_link` to create a link:

```html
<div>
    <a href="<%= stacker_link_url('another/stack/location') %>">Go to other location</a>
</div>
```

This will output a fully qualifies URL incl. base URL and the path.

Parameters can also be passed to the `create_stacker_link` function:

```html
<div>
    <a href="<%= stacker_link_url('another/stack/location', 'aKey' => 'aValue', 'bKey' => 'bValue') %>">Go to other location</a>
</div>
```

This will output a fully qualifies URL incl. the parameters passed, e.g.:

```
http://example.com/another/stack/location?=aValue&b=bValue
```

The output can also be combined with the standard Rails `link_to` tag:

```html
<div>
    <%= link_to 'text', stacker_link_url('stack/abc') %>
</div>
```

### Other functionalities

* [Lograge](https://github.com/roidrage/lograge) is automatically enabled
