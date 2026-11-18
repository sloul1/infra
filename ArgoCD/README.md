# ArgoCD

> [!WARNING]
> CHECK THE FACTS!  

> [!NOTE]
> Brave AI search prompt:
> Tell me about argocd and compare it to other similar tools in chart.



## Description  

ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes that treats Git as the single source of truth.  It features a robust web UI, built-in RBAC, and a centralized hub-and-spoke architecture, making it ideal for teams requiring visual dashboards and multi-tenant control. Its primary competitors include FluxCD, which offers a lighter, CLI-driven, modular controller set, and Jenkins X, which integrates CI and GitOps but faces declining community health. Other notable alternatives include Spinnaker for multi-cloud strategies and Harness for managed, AI-assisted enterprise delivery. 

The following chart compares the key GitOps and CD tools relevant in 2026:


| Tool | Architecture | UI / Interface | Multi-Cluster | Best Fit Scenario |
| :--- | :--- | :--- | :--- | :--- |
| **ArgoCD** | Centralized (Hub-and-Spoke) | Built-in Web UI | Strong (Single Instance) | Teams needing visibility, self-service, and central control. |
| **FluxCD** | Decentralized (Per-Cluster) | CLI-driven (No native UI) | Independent per Cluster | Teams wanting lean, automated GitOps with minimal overhead. |
| **Jenkins X** | Cloud-Native CI/CD | Web Dashboard | Limited | Teams wanting CI and GitOps owned by a single tool. |
| **Spinnaker** | Multi-Cloud CD | Web UI | Yes | Multi-cloud deploy strategies and complex pipelines. |
| **Harness** | Managed SaaS | Web Dashboard | Yes | Enterprise teams wanting AI-assisted, managed CD. |
| **Bunnyshell** | Environment Lifecycle | Web Dashboard | Yes | Teams needing preview environments and DORA metrics. |

> [!INFO]
> How does ArgoCD compare to FluxCD in performance?


## ArgoCD vs FluxCD — Performance
FluxCD is consistently lighter due to its modular, controller-only architecture (no UI, no Redis). ArgoCD's centralized platform (API server + repo server + controller + Redis + UI) carries a higher fixed cost. 

| Metric | FluxCD | ArgoCD |
|---|---|---|
| Memory (1,000 apps) | ~350–650 MB | ~1.4–4 GB |
| CPU (idle) | ~0.4–0.7 vCPU | ~0.9–1.8 vCPU |
| Reconciliation model | Per-resource interval (tunable per Kustomization) | Global interval (default 3 min) + webhooks |
| Git polling | Per-source (efficient) | Per-application |
| UI overhead | None | Significant (websocket state, Redis cache) |
| Scaling ceiling | Shard by label/namespace | ~3,000–5,000 apps before UI slowdowns (without tuning); ~50,000 with ArgoCD 3.3+ optimizations |
| Multi-cluster model | Per-cluster install (decentralized) | Centralized hub; shard ~1 controller per 15–20 clusters |  

> [!INFO]  
> What are ArgoCD's security best practices?  

## ArgoCD Security Best Practices
### Authentication & Access Control

Configure SSO (OIDC/SAML), then set admin.enabled: "false" — the local admin is a shared god-account.
Set policy.default to an empty or minimal role (deny-by-default).
Disable users.anonymous.enabled.
Restrict dangerous RBAC verbs: exec, override, clusters create, gpgkeys create → platform team only. 

### Least Privilege (Controller)

Replace the default cluster-admin ClusterRoleBinding with a scoped ClusterRole limited to the namespaces/resource types ArgoCD actually manages.
Enable the resource allowlist to block syncing of ClusterRoleBindings, PodSecurityPolicies, etc. 

### AppProject Hardening

Lock down the default project (empty sourceRepos, destinations, namespaceResourceBlacklist: */*).
Create one project per team/trust zone with explicit sources, destinations, and resource kinds. 

### Git & Credential Security

Use GitHub Apps or scoped deploy keys — never personal access tokens. 
Pin known_hosts for SSH; set insecureIgnoreHostKey: false.
Enable GPG commit verification on production projects.

### Secrets

Never commit plaintext Secrets to the GitOps repo. Use Sealed Secrets, External Secrets Operator, or SOPS so only ciphertext is stored in Git. 

### Network & Transport

Apply NetworkPolicies to all ArgoCD components (especially repo-server :8081 and Redis :6379). 
Enforce TLS between all internal components (internal mTLS arrives in ArgoCD 3.5).
Terminate TLS at the ingress and keep ArgoCD's own TLS enabled. 

### Operational

Enable audit logging.
Set resource quotas/limits on ArgoCD pods.
Run with readOnlyRootFilesystem, runAsNonRoot, and restricted Pod Security Standards.
Keep ArgoCD patched — treat unpatched CVEs (auth-bypass, SSRF, path-traversal classes) as standing incidents. 
