# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Sharebox::Application.initialize!

#Formatting date to look like "20/01/2011 10:28PM"
Time::DATE_FORMATS[:default] = "%d/%m/%Y %l:%M%p"