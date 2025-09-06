// Simple script to demonstrate CloudFront caching
document.addEventListener('DOMContentLoaded', function() {
    // Add loading time display
    const loadTime = performance.now();
    
    // Create performance info element
    const perfInfo = document.createElement('div');
    perfInfo.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: rgba(0,0,0,0.7);
        color: white;
        padding: 10px;
        border-radius: 5px;
        font-size: 12px;
    `;
    perfInfo.innerHTML = `Page loaded in: ${loadTime.toFixed(2)}ms`;
    document.body.appendChild(perfInfo);
    
    console.log('CloudFront + Terraform + S3 Demo loaded successfully!');
    console.log(`Load time: ${loadTime.toFixed(2)}ms`);
});