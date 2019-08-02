starter = -> { $app = App.start }
starter.()

# avoids the error: ArgumentError (A copy of App has been removed from the module tree but is still active!)
ActiveSupport::Reloader.to_prepare(&starter)
