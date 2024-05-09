def run_verification_job(job_name:str)->int:
    print(f"Running {job_name}...")
    
    # Prospector API Regression
    print("Prospector API Regression...")
    
    # e2e Integration Tests
    print("e2e Integration Tests...")
    
    # ui e2e tests
    print("ui e2e tests...")
    
    return 1    

if __name__ == "__main__":
    run_verification_job("verification_job")