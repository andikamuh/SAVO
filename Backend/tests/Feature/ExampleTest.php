<?php

test('the application redirects to admin login', function () {
    $response = $this->get('/');

    $response->assertRedirect('/savo/admin/login');
});
