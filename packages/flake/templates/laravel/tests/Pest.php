<?php

  use App\Models\User;
  use Laravel\Sanctum\Sanctum;
  use Saloon\Http\Faking\MockClient;

  pest()->extend(Tests\TestCase::class)
        ->beforeEach(function () {
            Sanctum::actingAs(
              User::factory()->create(),
              ['*']
            );
                  MockClient::destroyGlobal();
        })
 // ->use(Illuminate\Foundation\Testing\RefreshDatabase::class)
        ->in(__DIR__);
