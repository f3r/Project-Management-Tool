ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
 :date => '%d/%m/%Y',
 :date_time12  => "%d/%m/%Y %I:%M%p",
 :date_time24  => "%d/%m/%Y %H:%M",
 :full_date => "%A, %B %d, %Y",
 :short_date => "%B %d, %Y"
)