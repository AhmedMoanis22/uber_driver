import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../network/api_constant.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  String? _driverId;
  Function(Map<String, dynamic>)? onNewRideRequest;

  bool get isConnected => _socket?.connected ?? false;

  void init(String driverId) {
    _driverId = driverId;

    _socket = IO.io(
      ApiConstance.baseUrl.replaceAll('/api', ''),
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _setupListeners();
  }

  void _setupListeners() {
    _socket?.onConnect((_) {
      log('✅ Socket connected to server');
    });

    _socket?.onDisconnect((_) {
      log('❌ Socket disconnected from server');
    });

    _socket?.onConnectError((error) {
      log('🔴 Socket connection error: $error');
    });

    _socket?.onError((error) {
      log('🔴 Socket error: $error');
    });

    _socket?.onReconnect((_) {
      log('🔄 Socket reconnected');
      if (_driverId != null) {
        goOnline(_driverId!);
      }
    });

    // Listen for new ride requests
    _socket?.on('ride:new-request', (data) {
      log('🔔 New ride request received: $data');
      if (onNewRideRequest != null && data is Map<String, dynamic>) {
        onNewRideRequest!(data);
      }
    });
  }

  void connect() {
    if (_socket?.connected != true) {
      _socket?.connect();
      log('🔌 Attempting to connect socket...');
    }
  }

  void disconnect() {
    if (_driverId != null) {
      goOffline(_driverId!);
    }
    _socket?.disconnect();
    log('🔌 Socket disconnected');
  }

  void goOnline(String driverId) {
    if (_socket?.connected == true) {
      _socket?.emit('driver:online', driverId);
      log('🚗 Driver $driverId is now ONLINE');
    } else {
      log('⚠️ Cannot go online - socket not connected');
    }
  }

  void goOffline(String driverId) {
    if (_socket?.connected == true) {
      _socket?.emit('driver:offline', driverId);
      log('🚗 Driver $driverId is now OFFLINE');
    }
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
    _driverId = null;
    onNewRideRequest = null;
  }
}
