#include <stdio.h>
#include <stdlib.h>
#include <cjson/cJSON.h>
#include <libwebsockets.h>
#include <string.h>

static int websocket_callback(struct lws *wsi, enum lws_callback_reasons reason, void *user, void *in, size_t len) {
    switch (reason) {
        case LWS_CALLBACK_CLIENT_ESTABLISHED:{
            printf("Connected to server\n");
            lws_callback_on_writable(wsi);
            break;
        }

        case LWS_CALLBACK_CLIENT_WRITEABLE: {
            printf("Sending message to server\n");
            const char *message = "Hello, server!";
            unsigned char buf[LWS_PRE + strlen(message)];
            memcpy(&buf[LWS_PRE], message, strlen(message));
            lws_write(wsi, &buf[LWS_PRE], strlen(message), LWS_WRITE_TEXT);
            break;
        }

        case LWS_CALLBACK_CLIENT_RECEIVE:
            printf("Received: %.*s\n", (int)len, (const char *)in);
            break;

        case LWS_CALLBACK_CLIENT_CLOSED:
            printf("Connection closed\n");
            break;

        default:
            break;
    }
    return 0;
}

static struct lws_protocols protocols[] = {
    {
        "example-protocol",
        websocket_callback,
        0,
        0,
    },
    { NULL, NULL, 0, 0 }
};



int main(int argc, char *argv[])
{
    struct lws_context_creation_info info;
    memset(&info, 0, sizeof(info));

    info.options = LWS_SERVER_OPTION_DO_SSL_GLOBAL_INIT;
    info.protocols = protocols;

    struct lws_context *context = lws_create_context(&info);
    if (!context) {
        fprintf(stderr, "Failed to create context\n");
        return -1;
    }

    struct lws_client_connect_info ccinfo = {0};
    ccinfo.context = context;
    // ccinfo.address = "echo.websocket.org";
    // ccinfo.port = 443;
    ccinfo.address = "10.0.255.54";
    ccinfo.port = 443;
    ccinfo.path = "/";
    ccinfo.host = ccinfo.address;
    ccinfo.origin = ccinfo.address;
    ccinfo.protocol = protocols[0].name;

    struct lws *wsi = lws_client_connect_via_info(&ccinfo);
    if (!wsi) {
        fprintf(stderr, "Client connection failed\n");
        lws_context_destroy(context);
        return -1;
    }
    while (1) {
        lws_service(context, 1000);
    }
    lws_context_destroy(context);
    return 0;
}
