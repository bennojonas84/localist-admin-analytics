(function() {
    Slzr.jQuery(function($) {

        $('#custom_date_range').hide();

        $('#date_range_select').change(function(event) {
            if ($(this).val() === 'Custom') {
                return $('#custom_date_range').show();
            } else {
                return $('#custom_date_range').hide();
            }
        });

    });
}).call(this);