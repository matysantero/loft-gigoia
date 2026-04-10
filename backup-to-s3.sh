# Architecture Decision Records (ADR)

## ADR-001: Lightsail over EC2

**Decision:** Use AWS Lightsail instead of EC2 for hosting.

**Context:** The site is a small business with predictable traffic. Infrastructure management should be minimal so focus stays on business operations.

**Consequences:**
- Fixed monthly cost, no surprise bills
- Bitnami WordPress pre-configured, no manual LAMP setup
- Less flexibility than EC2 (no custom VPC, no fine-grained IAM per service)
- Acceptable trade-off for this use case

---

## ADR-002: CloudFront as CDN layer

**Decision:** Place CloudFront in front of Lightsail rather than using Lightsail's built-in CDN.

**Context:** Lightsail's CDN option does not support ACM certificates with custom domains in the same workflow. CloudFront provides full ACM integration, better cache control, and Shield Standard at no extra cost.

**Consequences:**
- SSL via ACM at no cost
- Global edge locations improve TTFB for EN/ES visitors
- Slightly more complex setup (two services instead of one)
- Origin must be configured as Lightsail static IP, not instance hostname

---

## ADR-003: S3 for backups over Lightsail snapshots only

**Decision:** Use S3 as primary backup destination alongside Lightsail snapshots.

**Context:** Lightsail snapshots are full-instance backups billed per GB. Restoring a single corrupted file requires full snapshot restore. S3 backups of wp-content and the database allow granular restore at lower cost.

**Consequences:**
- Lower backup storage cost
- Granular restore capability
- Requires cron job on instance to run wp-cli export + aws s3 cp
- Future automation path: replace cron with Lambda + EventBridge

---

## ADR-004: Polylang over WPML

**Decision:** Use Polylang for multilingual support instead of WPML.

**Context:** Three languages (PT/EN/ES), no WooCommerce, no complex translation workflows. WPML charges per-language and adds significant overhead for a simple informational site.

**Consequences:**
- Zero license cost
- Simpler admin interface
- Automatic hreflang tag generation
- Limited compared to WPML for complex translation management (not needed here)
