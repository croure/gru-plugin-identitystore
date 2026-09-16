package fr.paris.lutece.plugins.identitystore.business.identity;

import javax.validation.constraints.Size;
import java.io.Serializable;
import java.sql.Timestamp;

public class IdentityAccountHistory implements Serializable {
    private static final long serialVersionUID = 1L;

    @Size(max = 50, message = "#i18n{identitystore.validation.identity.ConnectionId.size}" )
    private String _strConnectionId;
    private int _nIdIdentity;
    private Timestamp _dateCreationDate;
    private Timestamp _dateDeletionDate;

    public String getConnectionId() {
        return _strConnectionId;
    }

    public void setConnectionId(final String _strConnectionId) {
        this._strConnectionId = _strConnectionId;
    }

    public int getIdIdentity() {
        return _nIdIdentity;
    }

    public void setIdIdentity(final int _nIdIdentity) {
        this._nIdIdentity = _nIdIdentity;
    }

    public Timestamp getCreationDate() {
        return _dateCreationDate;
    }

    public void setCreationDate(final Timestamp _dateCreationDate) {
        this._dateCreationDate = _dateCreationDate;
    }

    public Timestamp getDeletionDate() {
        return _dateDeletionDate;
    }

    public void setDeletionDate(final Timestamp _dateDeletionDate) {
        this._dateDeletionDate = _dateDeletionDate;
    }
}
