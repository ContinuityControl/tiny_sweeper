# TinySweeper

TinySweeper keeps your objects tidy!

It's a handy way to clean attributes on your Rails models, though it's independent of Rails, and can be used in any Ruby project. It gives you a light-weigt way to override your methods and declare how their inputs should be cleaned.

[![Build Status](https://travis-ci.org/ContinuityControl/tiny_sweeper.png?branch=master)](https://travis-ci.org/ContinuityControl/tiny_sweeper)

## How Do I Use It?

```ruby
class Sundae
  attr_accessor :topping

  include TinySweeper
  sweep(:topping) { |topping| topping.strip.downcase }
end
```

Now your Sundae toppings will be tidied up:

```ruby
dessert = Sundae.new
dessert.topping = ' ButTTERscotCH   '
dessert.topping #=> 'butterscotch'. Tidy!
```

If you have an object with lots of attributes that need cleaning, you can do that, too:

```ruby
dessert.sweep_up!
# or:
Sundae.sweep_up!(dessert)
```

### Future Ideas

Just spit-balling here...

It'd be nice to define sweep-ups for multiple fields.

If you often sweep up fields in the same way - say, squishing and nilifying blanks - it'd be nice to bundle that up in some way, so you don't have to repeat yourself. Something like this might be nice:

```ruby
# in config/initializers/tiny_sweeper.rb, or similar:
TinySweeper.sweep_style(:squish_and_nil_blanks) { |value|
  ...
}

class Sundae
  sweep :topping, :squish_and_nil_blanks
end
```

If TinySweeper doesn't know the sweeping technique you asked for, it would send it to the value in the typical symbol-to-proc fashion:

```ruby
class Sundae
  # This:
  sweep :topping, :strip
  # ...would be the same as this:
  sweep :topping { |t| t.strip }
end
```

## How Does It Work?

You include the `TinySweeper` module in your class, and define some sweep-up rules on your class' attributes. It overrides your method, and defines a new method that cleans its input according to the sweep-up rule, and then calls the original method with the clean value.

"Isn't it better to generate a module for the new methods, and call `super`?"

Sure, but if you do that, the module's method is called *after* the original one. We want to clean the input *before* it gets to your method.

"Why not use `after_create` or `before_save` or `before_validate` callbacks?"

That's one approach, and it's used by [nilify_blanks](https://github.com/rubiety/nilify_blanks), so it's clearly workable.

But it means your data isn't cleaned until the callback runs; TinySweeper cleans your data as soon as it arrives.

Also, it requires rails, so you can't use it outside of rails.

## Install It

The standard:

```
$ gem install tiny_sweeper
```

or add to your Gemfile:

```
gem 'tiny_sweeper'
```

## Contributing

Help is always appreciated!

* Fork the repo.
* Make your changes in a topic branch. Don't forget your specs!
* Send a pull request.

Please don't update the .gemspec or VERSION; we'll coordinate that when we release an update.
