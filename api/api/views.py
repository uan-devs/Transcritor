from django.http import JsonResponse


def api_home(request, *args, **kwargs):
    return JsonResponse(
        {
            "title": "Olá, Mundo!",
            "content": "Seja bem-vindo(a) à API do Transcritor!",
        }
    )
