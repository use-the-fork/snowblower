<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;
use App\Http\Resources\AuthenticatedUserResource;
use Tighten\Ziggy\Ziggy;

class HandleInertiaRequests extends Middleware
{
    /**
     * The root template that's loaded on the first page visit.
     *
     * @see https://inertiajs.com/server-side-setup#root-template
     *
     * @var string
     */
    protected $rootView = 'app';

    /**
     * Determines the current asset version.
     *
     * @see https://inertiajs.com/asset-versioning
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

  /**
   * Define the props that are shared by default.
   *
   * @return array<string, mixed>
   */
  public function share(Request $request): array
  {
    return [
      ...parent::share($request),
      'auth' => [
        'user' => $request->user() ? AuthenticatedUserResource::make($request->user()) : null,
      ],
      'ziggy' => fn () => [
        'location' => $request->url(),
        'query' => $request->query(),
        'route' => $request->route()->parameters(),
      ],
      'flash' => fn () => [
        'message' => $request->session()->get('message'),
        'type' => $request->session()->get('type') ?? 'success',
        'data' => $request->session()->get('data'),
      ],
    ];
  }
}
