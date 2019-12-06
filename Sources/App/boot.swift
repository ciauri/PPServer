import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    let job = QueryStateJob(application: app)
    job.sync()
}
