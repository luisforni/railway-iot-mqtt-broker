# railway-iot-mqtt-broker

Mosquitto MQTT 5.0 broker configuration for **railway-iot-platform**.

---

## Responsibilities

- Mosquitto MQTT 5.0 broker
- Topic schema: `rail/<zone>/<device_id>/<metric>`
- QoS policies: QoS 0 for telemetry, QoS 1 for alerts
- Authentication configuration (username/password via `MQTT_USERNAME` / `MQTT_PASSWORD`)

---

## Topic Schema

```
rail/<zone>/<device_id>/<metric>
```

Examples:

```
rail/zone-a/track-sensor-01/temperature
rail/zone-a/track-sensor-01/vibration
rail/zone-b/locomotive-07/rpm
rail/zone-b/locomotive-07/brake-pressure
rail/zone-c/axle-load-03/load-weight
```

### Subscription Patterns

| Pattern | Matches |
|---|---|
| `rail/#` | All sensor data (used by Django MQTT consumer) |
| `rail/zone-a/#` | All devices in zone-a |
| `rail/+/track-sensor-01/#` | All metrics from track-sensor-01 in any zone |

---

## Configuration

The broker is configured at container startup. Key settings:

| Setting | Value |
|---|---|
| Protocol | MQTT 5.0 |
| Port | 1883 (plaintext, dev only) |
| Persistence | Disabled (messages not stored to disk) |
| Authentication | Optional (set `MQTT_USERNAME` / `MQTT_PASSWORD` in `.env`) |

---

## Production Notes

- Enable TLS on port **8883** for production deployments
- Set `MQTT_USERNAME` and `MQTT_PASSWORD` in `.env` to require authentication
- Consider ACL rules to restrict which clients can publish to which topics
- Use QoS 1 + persistent sessions for critical alert topics

---

## Testing Connectivity

```bash
# Subscribe to all topics (requires mosquitto_clients)
docker compose exec mqtt mosquitto_sub -h localhost -t "rail/#" -v

# Publish a test message
docker compose exec mqtt mosquitto_pub -h localhost -t "rail/zone-a/test-01/temperature" \
  -m '{"device_id":"test-01","zone":"zone-a","metric":"temperature","value":25.0,"timestamp":"2026-03-17T10:00:00Z"}'
```
