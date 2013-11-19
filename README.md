SpainTVSLibrary
===============

Librería Objective-C que permite obtener la información para su descarga de los vídeos publicados por las principales cadenas de televisión española en sus respectivos sitios web mediante el API pública de PyDownTV (http://www.pydowntv.com)

# Ejemplo #

Vamos a ver cómo se obtiene la información de un vídeo mediante el API y cómo recuperamos la imagen asociada al vídeo

```objective-c
NSString *enlace = @"http://www.mitele.es/viajes/callejeros-viajeros/temporada-3/programa-109/";

[[DSSpainTVSClient sharedClient] recoverVideoInfo:enlace completionHandler:^(NSArray *info, NSError *error) 
{
    for(DSSpainTVSVideoInfo *video in info)
    {
        NSLog(@"%@", [video debugDescription]);
        [[DSSpainTVSClient sharedClient] recoverVideoImage:video.imagen completionHandler:^(UIImage *imagen, NSError *error) 
        {
            NSLog(@"Imagen (description): %@", [imagen description]);
        }];
    }
}];
```

# Estado #
* Versión 0.4 - Obtenemos la información asociada a un vídeo y recuperamos su imagen.
* Versión 0.1 - Yo no la usuario en producción forastero...
