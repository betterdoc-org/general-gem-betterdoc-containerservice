# Betterdoc::Containerservice

This gem is designed to encapsulate all the common functionality needed within our cointainer services (e.g. authentication and special log handling).

It's **very** opinionated based on what our team needs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'betterdoc-containerservice'
```

## Functionalities

The following functionalities are automatically added to your Rails application:

### Logging

Use the [Logging](https://github.com/TwP/logging) framework (incl. its [Railtie](https://github.com/TwP/logging-rails)) and setzp our common log format.

### Controllers

#### Authentication

**All** controller invocations require a valid JSON Web Token (JWT) either as HTTP header `Authoriaztion` in the format `Authorization: Bearer 1234567890ABCEEF` or as HTTP parameter `_jwt` in the format `1234567890ABCDEF`.

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

### Other functionalities

* [Lograge](https://github.com/roidrage/lograge) is automatically enabled
